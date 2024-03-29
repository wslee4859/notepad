﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;

namespace Web_service_login
{
    /// <summary>
    /// CheckLogin의 요약 설명입니다.
    /// </summary>
    [WebService(Namespace = "http://im.lottechilsung.co.kr/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // ASP.NET AJAX를 사용하여 스크립트에서 이 웹 서비스를 호출하려면 다음 줄의 주석 처리를 제거합니다. 
    // [System.Web.Script.Services.ScriptService]
    public class CheckLogin : System.Web.Services.WebService
    {
        //전역변수 선언.
        static string CheckCount = string.Empty;   //실패 누적 수 디폴터 5회 나중에 누적횟수도 변경할 수 있도록 추가개발.
        static string strConnString = ConfigurationManager.ConnectionStrings["TEST"].ConnectionString; // web.config 에서 connection 정보 가져오기.
        //SqlConnection con = new SqlConnection(strConnString);
        //SqlCommand cmd = new SqlCommand();
        [WebMethod]
        public string HelloWorld()
        {
            return "Hello World 담당자 BI/인사파트 이완상";
        }

        /// <summary>
        /// 계정 잠김 여부 체크 클래스
        /// 작 성 자 : BI/인사파트 이완상
        /// 수 정 자 : BI/인사파트 이완상
        /// 작성일자 : 2017-02월
        /// 수정일자 : 
        /// </summary>
        /// <param name="user_id"></param>
        /// <returns>Closed</returns>
        [WebMethod]
        public string CloseCheck(string login_id)
        {
            SqlConnection con = new SqlConnection(strConnString);
            SqlCommand cmd = new SqlCommand();
            //string CheckCount = string.Empty;   //실패 누적 수 디폴터 5회 나중에 누적횟수도 변경할 수 있도록 추가개발.
            //string strConnString = ConfigurationManager.ConnectionStrings["TEST"].ConnectionString; // web.config 에서 connection 정보 가져오기.
            //SqlConnection con = new SqlConnection(strConnString);
            //SqlCommand cmd = new SqlCommand();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "[IM].[ClosedUser_select_id]";
            cmd.Connection = con;

            try
            {
                con.Open();
                cmd.Parameters.Add("@login_id", SqlDbType.VarChar).Value = login_id;  // sp 파라미터로 login_id 전달.
                                                                                      //cmd.ExecuteNonQuery();

                //List 방식
                /*List<string> list = new List<string>();
                SqlDataReader reader = cmd.ExecuteReader();  //ExcuteReader 로 데이터베이스 결과값 읽어오기.
                while(reader.Read())
                {
                    list.Add(reader.GetString(0));
                    //Console.WriteLine("test");
                }
                reader.Close();
                */

                //DataTable 객체 생성
                DataTable myTable = new DataTable("myTable");    //DataTable 선언 이름 myTable                
                myTable.Load(cmd.ExecuteReader());  // myTable 에 SQL 쿼리한 데이터베이스 통째로 복사.
                con.Close();
                if (myTable.Rows.Count > 0)  // 잠긴 user_id 가 검색 될 경우
                {
                    string CheckId = myTable.Rows[0]["login_id"].ToString();   //datatable 첫번째 행의 컬럼명이 login_id 의 데이터를 가져온다.
                    CheckCount = myTable.Rows[0]["wrong_cnt"].ToString();
                    return CheckId + "계정은 로그인 실패 누적" + CheckCount + "회 이상으로 인해 잠김 처리 되었습니다. 패스워드 초기화 후 사용해 주세요.";

                }
                else
                {
                    return "OK";
                }
            }
            catch (Exception ex)
            {
                return "시스템 Error 담당자 (BI/인사파트 이완상) 문의하시기 바랍니다." + ex;
            }


        }

        /// <summary>
        /// 계정 로그인 실패시 실행 클래스
        /// 작 성 자 : BI/인사파트 이완상
        /// 수 정 자 : BI/인사파트 이완상
        /// 작성일자 : 2017-02월
        /// 수정일자 
        /// </summary>
        /// <param name="login_id"></param>
        /// <param name="system"></param>
        /// <param name="ip"></param>
        /// <returns></returns>
        [WebMethod]
        public string Access_Fail(string login_id, string system, string ip)
        {
            //전역변수 선언.
            //string CheckCount = string.Empty;   //실패 누적 수 디폴터 5회 나중에 누적횟수도 변경할 수 있도록 추가개발.
            //string strConnString = ConfigurationManager.ConnectionStrings["TEST"].ConnectionString; // web.config 에서 connection 정보 가져오기.
            //SqlConnection con = new SqlConnection(strConnString);
            //SqlCommand cmd = new SqlCommand();
            SqlConnection con = new SqlConnection(strConnString);
            SqlCommand cmd = new SqlCommand();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "[IM].[mst_login_log_insert_fail]";   // 저장프로시저명
            cmd.Connection = con;
            try
            {
                con.Open();
                cmd.Parameters.Add("@login_id", SqlDbType.VarChar).Value = login_id;  // sp 파라미터로 login_id 전달.
                cmd.Parameters.Add("@system", SqlDbType.VarChar).Value = system;  // sp 파라미터로 system 전달.
                cmd.Parameters.Add("@ip", SqlDbType.VarChar).Value = ip;  // sp 파라미터로 ip 전달.
                //cmd.ExecuteNonQuery(); //sp 실행

                //List 방식
                List<int> list = new List<int>();
                SqlDataReader reader = cmd.ExecuteReader();  //ExcuteReader 로 데이터베이스 결과값 읽어오기.
                while (reader.Read())
                {
                    list.Add(reader.GetInt16(0));
                    list.Add(reader.GetInt16(1));
                    //Console.WriteLine("test");
                }
                reader.Close();
                con.Close();
                if(list.Count > 0)
                {
                    if(list[0]==list[1])
                    {
                        return "로그인실패 누적" + list[0] + "회 입니다. 계정이 잠김 처리 되었습니다.";
                    }
                    else
                    {
                        return "로그인실패 누적" + list[0] + "회 입니다." + list[1] + "회 이상 실패할 경우 계정이 잠김 처리 됩니다.";
                    }
                    
                }               
                else
                {
                    throw new Exception("실패 카운트 못가져옴.");
                }

            }
            catch (Exception ex)
            {
                return "시스템 Error 담당자 (BI/인사파트 이완상) 문의하시기 바랍니다." + ex;
            }


        }

        /// <summary>
        /// 로그인 성공했을 때 이전 접속 기록 조회하여 IP가 맞는지 확인 
        /// 작 성 자 : 이완상
        /// 작성일자 : 2017-02-22
        /// 
        /// </summary>
        /// <param name="login_id"></param>
        /// <param name="system"></param>
        /// <param name="ip"></param>
        /// <returns></returns>
        [WebMethod]
        public string Access_Confirm(string login_id, string system, string ip)
        {            
            try
            {
                
                SqlConnection con = new SqlConnection(strConnString);
                SqlCommand cmd = new SqlCommand();
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Connection = con;
                //cmd 파라미터 변경 
                cmd.CommandText = "[IM].[mst_login_log_select]";            // 저장프로시저명
                con.Open();
                cmd.Parameters.Add("@login_id", SqlDbType.VarChar).Value = login_id;  // sp 파라미터로 login_id 전달.
                //List 방식
                List<string> list = new List<string>();
                SqlDataReader reader = cmd.ExecuteReader();  //ExcuteReader 로 데이터베이스 결과값 읽어오기.
                while (reader.Read())
                {
                    list.Add(reader.GetString(0));  //time
                    list.Add(reader.GetString(1));  //system
                    list.Add(reader.GetString(2));  //ip
                    //Console.WriteLine("test");
                }
                reader.Close();
                con.Close();

                if (list.Count > 0)
                {
                    if (ip == list[2]) // ip가 같을 경우 각 시스템별 정상 로직
                    {
                        Success(login_id, system, ip); // 접속 성공에 대한 이력 Insert                        
                        return "OK";
                    }
                    else
                    {
                        Success(login_id, system, ip); // 접속 성공에 대한 이력 Insert                     
                        return list[0] + " 경 " + list[2] + " PC에서 \n해당 계정으로 로그인 성공(실패) 이력이 있습니다.";
                    }
                }
                else // ip 못가져오면 처음 로그인 한 것. 
                {
                    //throw new Exception("실패 DB정보 가져올 수 없음.");
                    Success(login_id, system, ip); // 접속 성공에 대한 이력 Insert
                    return "OK";
                }
            }
            catch(Exception ex)
            {
                return "시스템 Error 담당자 (BI/인사파트 이완상) 문의하시기 바랍니다." + ex;
            }            
        }

        [WebMethod]
        public string ResetClosedUser(string login_id, string system, string ip)
        {
            try
            {
                SqlConnection con = new SqlConnection(strConnString);
                SqlCommand cmd = new SqlCommand();
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Connection = con;
                //cmd 파라미터 변경 
                cmd.CommandText = "[IM].[ClosedUser_delete]";            // 저장프로시저명
                con.Open();
                cmd.Parameters.Add("@login_id", SqlDbType.VarChar).Value = login_id;  // sp 파라미터로 login_id 전달.
                cmd.Parameters.Add("@system", SqlDbType.VarChar).Value = system;  // sp 파라미터로 login_id 전달.
                cmd.Parameters.Add("@ip", SqlDbType.VarChar).Value = ip;  // sp 파라미터로 login_id 전달.
                cmd.ExecuteNonQuery(); //sp 실행
                con.Close();
                return "OK";
            }
            catch (Exception ex)
            {
                return "시스템 Error 담당자 (BI/인사파트 이완상) 문의하시기 바랍니다." + ex;
            }

        }


        /// <summary>
        /// 성공했을 때 최종로그를 찍기 위한 내부 클래스
        /// 작 성 자 : BI/인사파트 이완상
        /// 수 정 자 : BI/인사파트 이완상
        /// 작성일자 : 2017-02월
        /// </summary>
        
        private void Success(string login_id, string system, string ip)
        {
           
            try
            {
                SqlConnection con = new SqlConnection(strConnString);
                SqlCommand cmd = new SqlCommand();
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Connection = con;
                cmd.CommandText = "[IM].[mst_login_log_insert_success]";            // 저장프로시저명
                con.Open();
                cmd.Parameters.Add("@login_id", SqlDbType.VarChar).Value = login_id;  // sp 파라미터로 login_id 전달.
                cmd.Parameters.Add("@system", SqlDbType.VarChar).Value = system;  // sp 파라미터로 system 전달.
                cmd.Parameters.Add("@ip", SqlDbType.VarChar).Value = ip;  // sp 파라미터로 ip 전달.
                cmd.ExecuteNonQuery(); //sp 실행
                con.Close();
            }
            catch (Exception ex)
            {
                 throw new Exception (""+ ex);
            }
        }
    }
}

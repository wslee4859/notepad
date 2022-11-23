.$env:exchangeinstallpath\bin\remoteexchange.ps1
connect-exchangeserver -Auto


/* 메일 사서함 카운트 */


get-mailbox -ResultSize unlimited -OrganizationalUnit "ou=영업본부,ou=롯데주류,ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr" | fl

/* 메일 사서함 카운트 영업본부 */
(get-mailbox -ResultSize unlimited -OrganizationalUnit "ou=영업본부,ou=롯데주류,ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr").count

get-mailbox -ResultSize unlimited -OrganizationalUnit "ou=영업본부,ou=롯데주류,ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr" | fl DisplayName, Identity, 



/* 메일 사서함 카운트 생산본부 */
(get-mailbox -ResultSize unlimited -OrganizationalUnit "ou=생산본부,ou=롯데주류,ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr").count


/* 메일 사서함 카운트 관리부문 */
(get-mailbox -ResultSize unlimited -OrganizationalUnit "ou=임원실,ou=롯데주류,ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr").count
(get-mailbox -ResultSize unlimited -OrganizationalUnit "ou=경영전략부문,ou=롯데주류,ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr").count
(get-mailbox -ResultSize unlimited -OrganizationalUnit "ou=경영지원부문,ou=롯데주류,ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr").count
(get-mailbox -ResultSize unlimited -OrganizationalUnit "ou=재경부문,ou=롯데주류,ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr").count
(get-mailbox -ResultSize unlimited -OrganizationalUnit "ou=준법경영부문,ou=롯데주류,ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr").count
(get-mailbox -ResultSize unlimited -OrganizationalUnit "ou=커뮤니케이션부문,ou=롯데주류,ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr").count


/* 메일 사서함 카운트 기타 */
(get-mailbox -ResultSize unlimited -OrganizationalUnit "ou=충북소주,ou=롯데주류,ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr").count
(get-mailbox -ResultSize unlimited -OrganizationalUnit "ou=주류연구소,ou=롯데주류,ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr").count
(get-mailbox -ResultSize unlimited -OrganizationalUnit "ou=직매장,ou=롯데주류,ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr").count
(get-mailbox -ResultSize unlimited -OrganizationalUnit "ou=MJA와인(주),ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr").count
(get-mailbox -ResultSize unlimited -OrganizationalUnit "ou=기타,ou=롯데주류,ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr").count



/* 사서함용량 예외 사용자 */

get-mailbox -ResultSize unlimited -Filter {UseDatabaseQuotaDefaults -eq "false"} | Select-Object alias, Identity, displayname, prohibitsendQuota, useDatabasequotadefaults | export-csv -path "\\lcsekw3exch01\file\wslee4859\190612.csv" -Encoding UTF8 





/* 음료 메일 사서함 카운트 */
(get-mailbox -ResultSize unlimited -OrganizationalUnit "OU=지원,OU=롯데칠성음료(주),OU=JJ,OU=Groups,OU=eKW,DC=lottechilsung,DC=co,DC=kr").count
(get-mailbox -ResultSize unlimited -OrganizationalUnit "OU=영업,OU=롯데칠성음료(주),OU=JJ,OU=Groups,OU=eKW,DC=lottechilsung,DC=co,DC=kr").count
(get-mailbox -ResultSize unlimited -OrganizationalUnit "OU=생산,OU=롯데칠성음료(주),OU=JJ,OU=Groups,OU=eKW,DC=lottechilsung,DC=co,DC=kr").count
(get-mailbox -ResultSize unlimited -OrganizationalUnit "OU=기타,OU=롯데칠성음료(주),OU=JJ,OU=Groups,OU=eKW,DC=lottechilsung,DC=co,DC=kr").count
(get-mailbox -ResultSize unlimited -OrganizationalUnit "OU=파견,OU=롯데칠성음료(주),OU=JJ,OU=Groups,OU=eKW,DC=lottechilsung,DC=co,DC=kr").count

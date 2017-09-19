#!/bin/sh
#This Script is used to drop some Test Files via these Protocols (FTP, SFTP and HTTP).
#Dated 			: April 2017.
#Author 		: M.S.Arun


#Execute Format
#sh <script_name> [space] <Account_Name> [space] <Login_Name/User_Name> [space] <Password> [space] <File_Size>
#Eg: sh Server_Testing_FTP_SFTP_HTTP_Auto_Edge.sh "user" "user" "password" 5


#****************************************************************** Start of Script ********************************************************************#


#Local Declarations
server_list=("localhost" "ftp.localhost.com" "sftp.localhost")
to_recipient="testuserto@xyz.com"
cc_recipient="testusercc@xyz.com"
logs_path="`pwd`/Server_Testing_FTP_SFTP_HTTP_Logs" #Note: Don't include "/" Forward Slash at the end of path.
outbound_username="admin"
outbound_password="password"
#server_username=""
#server_password=""
current_date_time=$(date +'%m-%d-%Y|%H_%M_%S')


user_account_test() {
host_name="${server_list[0]}"
curl -k -u "$server_username":"$server_password" ftp://$host_name:21/ > /dev/null 2>&1
connection_status="$?"
if [ "$connection_status" == 0 ]; then
	echo -e "`date` - $host_name - Connection - Success" > /dev/null 2>&1
else
	echo -e "`date` - $host_name - Connection - Failed"
	exit
fi
}


ftp_inbound_exe() {
for ((i=0;i<"${#server_list[*]}";i++)); do
host_name="${server_list[$i]}"
cp "$logs_path/testfile.test" "$logs_path/ftp_testfile_inbound_$host_name.test"; echo -e "This is a Test File\n`date`|$host_name|FTP|Inbound" >> "$logs_path/ftp_testfile_inbound_$host_name.test"
curl -k -T "$logs_path/ftp_testfile_inbound_$host_name.test" -u "$server_username":"$server_password" ftp://$host_name:21/puts/ > /dev/null 2>&1
connection_status="$?"
if [ "$connection_status" == 0 ]; then
	echo -e "`date` - $host_name - FTP - Inbound - Success"
	echo "`date`|FTP|Inbound|Success|$host_name" >> "$logs_path/Server_Testing_FTP_SFTP_HTTP_Logs.log"
else
	echo -e "`date` - $host_name - FTP - Inbound - Failed"
	echo "`date`|FTP|Inbound|Failed|$host_name" >> "$logs_path/Server_Testing_FTP_SFTP_HTTP_Logs.log"
fi
rm -f "$logs_path/ftp_testfile_inbound_$host_name.test" > /dev/null 2>&1
done
}


ftp_outbound_exe() {
for ((i=0;i<"${#server_list[*]}";i++)); do
host_name="${server_list[$i]}"
cp "$logs_path/testfile.test" "$logs_path/$server_accountname.0.ftp_testfile_outbound_$host_name.test"; echo -e "This is a Test File\n`date`|$host_name|FTP|Outbound" >> "$logs_path/$server_accountname.0.ftp_testfile_outbound_$host_name.test"
curl -k -T "$logs_path/$server_accountname.0.ftp_testfile_outbound_$host_name.test" -u "$outbound_username":"$outbound_password" ftp://$host_name:21/ > /dev/null 2>&1
connection_status="$?"
if [ "$connection_status" == 0 ]; then
	echo -e "`date` - $host_name - FTP - Outbound - Success"
	echo "`date`|FTP|Outbound|Success|$host_name" >> "$logs_path/Server_Testing_FTP_SFTP_HTTP_Logs.log"
else
	echo -e "`date` - $host_name - FTP - Outbound - Failed"
	echo "`date`|FTP|Outbound|Failed|$host_name" >> "$logs_path/Server_Testing_FTP_SFTP_HTTP_Logs.log"
fi
rm -f "$logs_path/$server_accountname.0.ftp_testfile_outbound_$host_name.test"  > /dev/null 2>&1
done
}


sftp_inbound_exe() {
for ((i=0;i<"${#server_list[*]}";i++)); do
host_name="${server_list[$i]}"
cp "$logs_path/testfile.test" "$logs_path/sftp_testfile_inbound_$host_name.test"; echo -e "This is a Test File\n`date`|$host_name|SFTP|Inbound" >> "$logs_path/sftp_testfile_inbound_$host_name.test"
curl -k -T "$logs_path/sftp_testfile_inbound_$host_name.test" -u "$server_username":"$server_password" sftp://$host_name:22/puts/ > /dev/null 2>&1
connection_status="$?"
curl -k -T "$logs_path/sftp_testfile_inbound_$host_name.test" -u "$server_username":"$server_password" sftp://$host_name:10022/puts/ > /dev/null 2>&1
spl_connection_status="$?"
if [ "$connection_status" == 0 ] || [ "$spl_connection_status" == 0 ]; then
	echo -e "`date` - $host_name - SFTP - Inbound - Success"
	echo "`date`|SFTP|Inbound|Success|$host_name" >> "$logs_path/Server_Testing_FTP_SFTP_HTTP_Logs.log"
else
	echo -e "`date` - $host_name - SFTP - Inbound - Failed"
	echo "`date`|SFTP|Inbound|Failed|$host_name" >> "$logs_path/Server_Testing_FTP_SFTP_HTTP_Logs.log"
fi
rm -f "$logs_path/sftp_testfile_inbound_$host_name.test" > /dev/null 2>&1
done
}


sftp_outbound_exe() {
for ((i=0;i<"${#server_list[*]}";i++)); do
host_name="${server_list[$i]}"
cp "$logs_path/testfile.test" "$logs_path/$server_accountname.0.sftp_testfile_outbound_$host_name.test"; echo -e "This is a Test File\n`date`|$host_name|SFTP|Outbound" >> "$logs_path/$server_accountname.0.sftp_testfile_outbound_$host_name.test"
curl -k -T "$logs_path/$server_accountname.0.sftp_testfile_outbound_$host_name.test" -u "$outbound_username":"$outbound_password" sftp://$host_name:22/ > /dev/null 2>&1
connection_status="$?"
curl -k -T "$logs_path/$server_accountname.0.sftp_testfile_outbound_$host_name.test" -u "$outbound_username":"$outbound_password" sftp://$host_name:10022/ > /dev/null 2>&1
spl_connection_status="$?"
if [ "$connection_status" == 0 ] || [ "$spl_connection_status" == 0 ]; then
	echo -e "`date` - $host_name - SFTP - Outbound - Success"
	echo "`date`|SFTP|Outbound|Success|$host_name" >> "$logs_path/Server_Testing_FTP_SFTP_HTTP_Logs.log"
else
	echo -e "`date` - $host_name - SFTP - Outbound - Failed"
	echo "`date`|SFTP|Outbound|Failed|$host_name" >> "$logs_path/Server_Testing_FTP_SFTP_HTTP_Logs.log"
fi
rm -f "$logs_path/$server_accountname.0.sftp_testfile_outbound_$host_name.test" > /dev/null 2>&1
done
}


http_inbound_exe() {
for ((i=0;i<"${#server_list[*]}";i++)); do
host_name="${server_list[$i]}"
curl -k -c "$logs_path/http_cookies.txt" -u "$server_username":"$server_password" "https://$host_name:443" > /dev/null 2>&1
cp "$logs_path/testfile.test" "$logs_path/http_testfile_inbound_$host_name.test"; echo -e "This is a Test File\n`date`|$host_name|HTTP|Inbound" >> "$logs_path/http_testfile_inbound_$host_name.test"
curl -k -b "$logs_path/http_cookies.txt" -T "$logs_path/http_testfile_inbound_$host_name.test" -u "$server_username":"$server_password" "https://$host_name:443/puts/" > /dev/null 2>&1
connection_status="$?"
if [ "$connection_status" == 0 ]; then
	echo -e "`date` - $host_name - HTTP - Inbound - Success"
	echo "`date`|HTTP|Inbound|Success|$host_name" >> "$logs_path/Server_Testing_FTP_SFTP_HTTP_Logs.log"
else
	echo -e "`date` - $host_name - HTTP - Inbound - Failed"
	echo "`date`|HTTP|Inbound|Failed|$host_name" >> "$logs_path/Server_Testing_FTP_SFTP_HTTP_Logs.log"
fi
rm -f "$logs_path/http_cookies.txt" > /dev/null 2>&1
rm -f "$logs_path/http_testfile_inbound_$host_name.test" > /dev/null 2>&1
done
}


http_outbound_exe() {
for ((i=0;i<"${#server_list[*]}";i++)); do
host_name="${server_list[$i]}"
curl -k -c "$logs_path/http_cookies.txt" -u "$outbound_username":"$outbound_password" "https://$host_name:443" > /dev/null 2>&1
cp "$logs_path/testfile.test" "$logs_path/$server_accountname.0.http_testfile_outbound_$host_name.test"; echo -e "This is a Test File\n`date`|$host_name|HTTP|Outbound" >> "$logs_path/$server_accountname.0.http_testfile_outbound_$host_name.test"
curl -k -b "$logs_path/http_cookies.txt" -T "$logs_path/$server_accountname.0.http_testfile_outbound_$host_name.test" -u "$outbound_username":"$outbound_password" "https://$host_name:443/" > /dev/null 2>&1
connection_status="$?"
if [ "$connection_status" == 0 ]; then
	echo -e "`date` - $host_name - HTTP - Outbound - Success"
	echo "`date`|HTTP|Outbound|Success|$host_name" >> "$logs_path/Server_Testing_FTP_SFTP_HTTP_Logs.log"
else
	echo -e "`date` - $host_name - HTTP - Outbound - Failed"
	echo "`date`|HTTP|Outbound|Failed|$host_name" >> "$logs_path/Server_Testing_FTP_SFTP_HTTP_Logs.log"
fi
rm -f "$logs_path/http_cookies.txt" > /dev/null 2>&1
rm -f "$logs_path/$server_accountname.0.http_testfile_outbound_$host_name.test" > /dev/null 2>&1
done
}

#Temporary Files Deletion Function
temp_deletion()
{
rm -f "$logs_path/testfile.test" > /dev/null 2>&1
rm -f "$logs_path/Server_Testing_FTP_SFTP_HTTP_Logs.log" > /dev/null 2>&1
rm -f "$logs_path/Server_Testing_FTP_SFTP_HTTP_Logs_$current_date.txt" > /dev/null 2>&1
rm -rf "$logs_path" > /dev/null 2>&1
}

#Mail Send Function
send_mail()
{
cat "$logs_path/Server_Testing_FTP_SFTP_HTTP_Logs.log" | column -t -s "|" | awk '{print NR".",$0}' > "$logs_path/Server_Testing_FTP_SFTP_HTTP_Logs_$current_date.txt"
mail_content=$(echo -e "Hello Team,\n\nPlease Find Server Testing Logs below,\n" && echo -e "Current Date and Time|:|`date`." | column -t -s "|" && echo -e "\n`cat "$logs_path/Server_Testing_FTP_SFTP_HTTP_Logs_$current_date.txt"`" && echo -e "\n")
echo -e "\n$mail_content\n\nRegards,\nTech Support.\n\n\n\n*** This is an auto generated email.\n" | mailx -s "Server Testing Logs - `hostname` - `date`" -c "$cc_recipient" "$to_recipient"
}


#Main Program
#Function to Call FTP, SFTP and HTTP
server_accountname="$1"
server_username="$2"
server_password="$3"
file_size="$4"

temp_deletion

user_account_test

#Creates a Junk File of the user defined size.
mkdir -p "$logs_path"
fallocate -l "$file_size"M "$logs_path/testfile.test"

ftp_inbound_exe
ftp_outbound_exe
sftp_inbound_exe
sftp_outbound_exe
http_inbound_exe
http_outbound_exe
send_mail
temp_deletion


#****************************************************************** End of Script ******************************************************************#

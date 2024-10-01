<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=Content-Type content="text/html; charset=windows-1252"></HEAD>
<BODY><PRE>-------------------------------------------------
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;

//**************************************************************************
***
//
//Module:
//ChangePasswordEntry
// @author Kimball Dlouhy
//
//Call Syntax:
//http://my.domain.com:9000/ChangePasswordEntry?
//  strHost=beans&amp;strSID=palpha
//
//Arguments:
//  strHost         The host that the database resides on
//  strSID          The Oracle SID of the database
//
//Details/Notes:
//This servlet creates a change password form and populate some hidden form 
//fields with the Host and SID to pass to ChangePassword which 
//actually atttempts to change the database password.
//**************************************************************************
***
//Module History:
//When        Who         What
//07/01/2002  K Dlouhy    Created.
//**************************************************************************
***
public class ChangePasswordEntry extends HttpServlet 
{
  private static final String CONTENT_TYPE = "text/html;
charset=windows-1252";

  public void init(ServletConfig config) throws ServletException
  {
    super.init(config);
  }

  public void doGet(HttpServletRequest request, HttpServletResponse
response)
throws ServletException, IOException
  {
    Vector vBodyElements = new Vector(100, 100);
    String strHost = "";
    String strSID = "";
    String strBody = "";
    boolean bOK = true;
    
    // get the values of the parameters
    try {
      strHost = request.getParameter("strHost");
      strSID = request.getParameter("strSID");
    } catch(Exception e) {
      strBody = e.toString();
      bOK = false;
    }

    //make sure that all fields are filled in and that the new password
entries
match
    if (strHost == null || strHost == "") {
      strBody = "\nMissing Host name.";
      bOK = false;
    } else if  (strSID == null || strSID == "") {
      strBody = "\nMissing Oracle SID.";
      bOK = false;
    }

    if (bOK) {
      strBody += "  &lt;H3&gt;Change Password&lt;/H3&gt;\n";
      strBody += "\n";
      strBody += "&lt;SCRIPT language=javascript&gt;\n";
      strBody += "  &lt;!--\n";
      strBody += "\n";
      strBody += " 
//*******************************************************************\n";
      strBody += "  //This script validates the entry fields and then
submits
the form.\n";
      strBody += "  //\n";
      strBody += "  //The submit action of the form calls a JWEB cartridge
which
in turn\n";
      strBody += "  //calls a PL/SQL procedure using JDBC.\n";
      strBody += "  //\n";
      strBody += "  //06/6/2000  Kimball Dlouhy  Created\n";
      strBody += " 
//*******************************************************************\n";
      strBody += "  function closeWindow() {\n";
      strBody += "    window.close()\n";
      strBody += "  }\n";
      strBody += "\n";
      strBody += "  //Create URL by putting all the form elements
together\n";
      strBody += "  function changePassword() {\n";
      strBody += "    if ( document.ChangePass.strUserName.value == \"\"  )
{\n";
      strBody += "      alert( \"Please enter your User Name.\")\n";
      strBody += "      return(-1)\n";
      strBody += "  }\n";
      strBody += "    if ( document.ChangePass.strOldPassword.value == \"\"
)
{\n";
      strBody += "      alert( \"Please enter your Old Password.\")\n";
      strBody += "      return(-1)\n";
      strBody += "  }\n";
      strBody += "    if ( document.ChangePass.strNewPassword.value == \"\"
)
{\n";
      strBody += "      alert( \"Please enter your New Password.\")\n";
      strBody += "      return(-1)\n";
      strBody += "  }\n";
      strBody += "    if ( document.ChangePass.strRetypePassword.value ==
\"\" 
) {\n";
      strBody += "      alert( \"Please retype your New Password.\")\n";
      strBody += "      return(-1)\n";
      strBody += "  }\n";
      strBody += "    if (
document.ChangePass.strRetypePassword.value.toUpperCase() !=
document.ChangePass.strNewPassword.value.toUpperCase() ) {\n";
      strBody += "      alert( \"Your new password entries do not match.
Please
enter them again.\")\n";
      strBody += "    document.ChangePass.strNewPassword.value = \"\"\n";
      strBody += "    document.ChangePass.strRetypePassword.value = \"\"\n";
      strBody += "      return(-1)\n";
      strBody += "  }\n";
      strBody += "\n";
      strBody += "    document.ChangePass.submit()\n";
      strBody += "  }\n";
      strBody += "  //--&gt;\n";
      strBody += "&lt;/SCRIPT&gt;\n";
      strBody += "\n";
      strBody += "  &lt;FORM name=\"ChangePass\" METHOD=post
ACTION=\"ChangePassword\"&gt;\n";
      strBody += "    &lt;input type=\"hidden\" name=strHost
value=\""+strHost+"\"&gt;\n";
      strBody += "    &lt;input type=\"hidden\" name=strSID
value=\""+strSID+"\"&gt;\n";
      strBody += "\n";
      strBody += "    &lt;table cellspacing=\"0\" cellpadding=\"10\"
width=\"360\"
height=\"100\"&gt;\n";
      strBody += "\n";
      strBody += "      &lt;tr&gt;\n";
      strBody += "      &lt;td width=\"190\" height=\"20\" align=\"right\"
&gt;\n";
      strBody += "        Enter User Name\n";
      strBody += "        &lt;/td&gt;\n";
      strBody += "        &lt;td width=\"190\"&gt;\n";
      strBody += "        &lt;input type=\"text\" name=strUserName &gt;\n";
      strBody += "        &lt;/td&gt;\n";
      strBody += "      &lt;/tr&gt;\n";
      strBody += "    &lt;tr&gt;\n";
      strBody += "      &lt;td width=\"200\" height=\"20\" align=\"right\"&gt;\n";
      strBody += "          Enter Old Password\n";
      strBody += "        &lt;/td&gt;\n";
      strBody += "        &lt;td&gt;\n";
      strBody += "        &lt;input type=\"password\" name=strOldPassword &gt;\n";
      strBody += "      &lt;/td&gt;\n";
      strBody += "    &lt;/tr&gt;\n";
      strBody += "    &lt;tr&gt;\n";
      strBody += "      &lt;td width=\"200\" height=\"20\" align=\"right\"&gt;\n";
      strBody += "          Enter New Password\n";
      strBody += "        &lt;/td&gt;\n";
      strBody += "        &lt;td&gt;\n";
      strBody += "        &lt;input type=\"password\" name=strNewPassword &gt;\n";
      strBody += "      &lt;/td&gt;\n";
      strBody += "    &lt;/tr&gt;\n";
      strBody += "    &lt;tr&gt;\n";
      strBody += "      &lt;td width=\"190\" height=\"20\" align=\"right\"&gt;\n";
      strBody += "          Retype New Password\n";
      strBody += "        &lt;/td&gt;\n";
      strBody += "        &lt;td&gt;\n";
      strBody += "        &lt;input type=\"password\" name=strRetypePassword
&gt;\n";
      strBody += "      &lt;/td&gt;\n";
      strBody += "    &lt;/tr&gt;\n";
      strBody += "\n";
      strBody += "    &lt;tr&gt;\n";
      strBody += "      &lt;td width=\"200\" height=\"20\" align=\"right\"&gt;\n";
      strBody += "           &lt;INPUT type=\"button\" value=\"Cancel\"
onClick=\"closeWindow()\"&gt;\n";
      strBody += "        &lt;/td&gt;\n";
      strBody += "        &lt;td&gt;\n";
      strBody += "        &lt;INPUT type=\"button\" value=\"Change Password\"
onClick=\"changePassword()\"&gt;\n";
      strBody += "      &lt;/td&gt;\n";
      strBody += "    &lt;/tr&gt;\n";
      strBody += "    &lt;/table&gt;\n";
      strBody += "  &lt;/FORM&gt;\n";
      strBody += "\n";
    }

    response.setContentType(CONTENT_TYPE);
    PrintWriter out = response.getWriter();
    out.println("&lt;html&gt;");
    out.println("&lt;head&gt;&lt;title&gt;ChangePasswordEntry&lt;/title&gt;&lt;/head&gt;");
    out.println("&lt;body&gt;");
    out.println(strBody);
    out.println("&lt;/body&gt;&lt;/html&gt;");
    out.close();

  }
}

--------------------------------------------------------

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;
import javax.sql.*;
import java.sql.*;


//**************************************************************************
***
//Module:
//ChangePassword
// @author Kimball Dlouhy
//
//Call Syntax:
//http://my.domain.com:9000/tomcat/ChangePassword?
//  strHost=beans&amp;strSID=palpha&amp;strUserName=flinstone&amp;
//  strOldPassword=fred&amp;strNewPassword=wilma&amp;strRetypePassword=wilma
//
//Arguments:
//  strHost             The host that the database resides on
//  strSID              The Oracle SID of the database
//  strUserName         The Oracle user name whose password you want to
change
//  strOldPassword      The existing oracle password
//  strNewPassword      The new password
//  strRetypePassword   Verification of the new password
//
//Details/Notes:
//This servlet connects to the database with the user name and old password
//and then attempts to change the Oracle password. The success or failure is
//sent back as an HTML page.
//**************************************************************************
***
//Module History:
//When        Who         What
//07/01/2002  K Dlouhy    Created.
//**************************************************************************
***
public class ChangePassword extends HttpServlet 
{
  private static final String CONTENT_TYPE = "text/html;
charset=windows-1252";

  public void init(ServletConfig config) throws ServletException
  {
    super.init(config);
  }

  public void doPost(HttpServletRequest request, HttpServletResponse
response)
throws ServletException, IOException
  {
    Vector vBodyElements = new Vector(100, 100);
    String strHost = "";
    String strSID = "";
    String strUserName = "";
    String strOldPassword = "";
    String strNewPassword = "";
    String strRetypePassword = "";
    boolean bOK = true;
    int n = 0;
    
    // get the values of the parameters
    try {
      strHost = request.getParameter("strHost");
      strSID = request.getParameter("strSID");
      strUserName = request.getParameter("strUserName");
      strOldPassword = request.getParameter("strOldPassword");
      strNewPassword = request.getParameter("strNewPassword");
      strRetypePassword = request.getParameter("strRetypePassword");
    } catch(Exception e) {
      vBodyElements.addElement(e.toString());
      bOK = false;
    }

    // Load the Oracle JDBC driver
    try {
      Class.forName ("oracle.jdbc.driver.OracleDriver");
    } catch (ClassNotFoundException ex) {
      vBodyElements.addElement("\nUnable to find Oracle Driver Class " +
ex.toString());
      bOK = false;
    }

    if (bOK) {
      changePassword(vBodyElements, strHost, strSID, strUserName,
strOldPassword, strNewPassword, strRetypePassword);
    }

    response.setContentType(CONTENT_TYPE);
    PrintWriter pwOut = response.getWriter();
    pwOut.println("&lt;html&gt;");
    pwOut.println("&lt;head&gt;&lt;title&gt;ChangePassword&lt;/title&gt;&lt;/head&gt;");
    pwOut.println("&lt;body&gt;");
    pwOut.println("&lt;H1&gt;");
    pwOut.println("Change Password Results");
    pwOut.println("&lt;/H1&gt;");
    pwOut.println("&lt;p&gt;");
    pwOut.println("&lt;H3&gt;");
    
    for (n = 0; n &lt; vBodyElements.size(); n++) {
      pwOut.println("&lt;p&gt;" + vBodyElements.elementAt(n).toString() + "&lt;/p&gt;");
    }
    
    pwOut.println("&lt;/H3&gt;");
 
    pwOut.println("\n&lt;p&gt;\n&lt;CENTER&gt;\n");
    pwOut.println("&lt;SCRIPT language=javascript&gt;\n");
    pwOut.println("  &lt;!--\n");
    pwOut.println("  function closeWindow() {\n");
    pwOut.println("    window.close()\n");
    pwOut.println("  }\n");
    pwOut.println("  //--&gt;\n");
    pwOut.println("&lt;/SCRIPT&gt;\n");
    pwOut.println("&lt;FORM name=\"results\" METHOD=post ACTION=\"\"&gt;\n");
    pwOut.println("  &lt;INPUT type=\"button\" value=\"Close\"
onClick=\"closeWindow()\"&gt;\n");
    pwOut.println("&lt;/FORM&gt;\n&lt;/CENTER&gt;\n");
    pwOut.println("&lt;/body&gt;&lt;/html&gt;");
    pwOut.close();

  }

//**************************************************************************
***
//Module:
//ChangePassword
// @author Kimball Dlouhy
//
//Call Syntax:
//changePassword( vBodyElements, "beans", "palpha", "flinstone", "fred",
"wilma",
//  "wilma")
//
//Arguments:
//  vBodyElements       The vector that holds the body of the HTML page
//  strHost             The host that the database resides on
//  strSID              The Oracle SID of the database
//  strUserName         The Oracle user name whose password you want to
change
//  strOldPassword      The existing oracle password
//  strNewPassword      The new password
//  strRetypePassword   Verification of the new password
//
//Details/Notes:
//This method connects to the database using JDBC with the user name and old
//password and then attempts to change the Oracle password using a stored
//procedure in the database.
//**************************************************************************
***
//Module History:
//When        Who         What
//07/01/2002  K Dlouhy    Created.
//**************************************************************************
***
  public void changePassword(Vector vBodyElements, String strHost, String
strSID, String strUserName, String strOldPassword, String strNewPassword,
String
strRetypePassword) {
    Connection conn = null;

    //make sure that all fields are filled in and that the new password
entries
match
    if (strHost == null || strHost == "") {
      vBodyElements.addElement("\nMissing Host name.");
    } else if  (strSID == null || strSID == "") {
      vBodyElements.addElement("\nMissing Oracle SID.");
    } else if  (strUserName == null || strUserName.equals("")) {
      vBodyElements.addElement("\nMissing user name.");
    } else if  (strOldPassword == null || strOldPassword.equals("")) {
      vBodyElements.addElement("\nMissing old password.");
    } else if  (strNewPassword == null || strNewPassword.equals("")) {
      vBodyElements.addElement("\nMissing new password.");
    } else if  (strRetypePassword == null || strRetypePassword.equals("")) {
      vBodyElements.addElement("\nMissing retype new password.");
    } else if  (strNewPassword.equalsIgnoreCase(strRetypePassword) == false)
{
      vBodyElements.addElement("\nThe new password was typed
inconsistently.");
    } else {
      try {
        if (conn == null || conn.isClosed()) {

          // Connect to the database. To connect to a remote database,
          // insert the connect string after the @ sign in the connection
URL.
          conn = DriverManager.getConnection
("jdbc:oracle:thin:@"+strHost+":1521:"+strSID, strUserName, strOldPassword);
        }

        try {
          //create the statement
          CallableStatement l_stmt =
            conn.prepareCall("begin
SMITHS_DBA.DBA_USER_PACKAGE.CHANGE_PASSWORD(?,?); end;");

          // Binds the parameter Types and their types
          l_stmt.setString(1,strUserName);
          l_stmt.setString(2,strNewPassword);

          // Execute the callable statement
          l_stmt.execute();

          // close the statement
          l_stmt.close();

          vBodyElements.addElement("\nYour password has been successfully
changed.");
        }catch (SQLException ex) { // Trap SQL Errors
          vBodyElements.addElement("\nError while Calling PL/SQL Procedure "
+
ex.toString());
        }

        conn.close();

      }catch (SQLException ex) { // Trap SQL Errors
        vBodyElements.addElement("\nError connecting to database " +
ex.toString());
      }
    }
  }

}


--------------------
</PRE></BODY></HTML>

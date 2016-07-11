using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        System.Data.SqlClient.SqlConnection conn = new System.Data.SqlClient.SqlConnection();
        conn.ConnectionString = @"Data Source=(localdb)\MSSQLLocalDB;
                                    Initial Catalog=Database1;
                                    Integrated Security=True;
                                    AttachDBFilename=|DataDirectory|\Database1.mdf;";
        conn.Open();
        conn.Close();
    }
}
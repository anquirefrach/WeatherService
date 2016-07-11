using System;
using System.Collections;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.Net;
using System.IO;
using System.Collections.Generic;

namespace Samples.Aspnet
{
    /// <summary>
    /// Summary description for HelloWorld
    /// </summary>
    [WebService(Namespace = "http://mycompany.org")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class HelloWorld : System.Web.Services.WebService
    {

        public HelloWorld()
        {

            //Uncomment the following line if using designed components 
            //InitializeComponent(); 
        }

        [WebMethod]
        public string Greetings()
        {
            string serverTime =
                            String.Format("Current date and time: {0}.", DateTime.Now);
            string greetings = "Hello World! <br/>" + serverTime;
            return greetings;
        }

        private SqlCommand GetConnectionString(string commandText)
        {
            ConnectionStringSettings settings = ConfigurationManager.ConnectionStrings["WeatherDataConnectionString"];
            SqlConnection sqlConn = new SqlConnection(settings.ConnectionString);
            SqlCommand sqlComm = new SqlCommand();
            sqlComm.CommandText = commandText;
            sqlComm.Connection = sqlConn;
            sqlComm.CommandType = System.Data.CommandType.StoredProcedure;
            return sqlComm;
        }

        [WebMethod]
        public string Weather(string longitude, string latitude, string mainWeather, string minMaxTemp, string sunriseSunset, string pressure, string humidity, string wind)

        {
            SqlCommand sqlComm = GetConnectionString("GetCityId");
            sqlComm.Parameters.Add("@longitude", SqlDbType.Int);
            sqlComm.Parameters["@longitude"].Value = Convert.ToInt32(longitude);
            sqlComm.Parameters.Add("@latitude", SqlDbType.Int);
            sqlComm.Parameters["@latitude"].Value = Convert.ToInt32(latitude);
            try
            { 
                using (sqlComm.Connection)
                {
                    using (sqlComm)
                    {
                        sqlComm.Connection.Open();
                        return GetCityWeather(Convert.ToInt32(sqlComm.ExecuteScalar()), mainWeather, minMaxTemp, sunriseSunset, pressure, humidity, wind);
                    }
                }
            }
            catch(SqlException sqlException)
            {
                //return ("There is no data at this time");
                return sqlException.Message;
            }
        }

        private string GetCityWeather(int Id, string mainWeather, string minMaxTemp, string sunriseSunset, string pressure, string humidity, string wind)
        {
            DataTable dataTable = GetImportedWeather(Id);

            if (CheckLastPullDateTime(dataTable).Minutes > 10)
            {
                    ImportWeather(Id);
                    dataTable = GetImportedWeather(Id);
            }

            return FormatWeather(GetFilterList(mainWeather, minMaxTemp, sunriseSunset, pressure, humidity, wind), dataTable);
        }

        private List<string>  GetFilterList(string mainWeather, string minMaxTemp, string sunriseSunset, string pressure, string humidity, string wind)
        {
            List<string> filterList = new List<string>();
            filterList.Add("City");
            filterList.Add(mainWeather);
            filterList.Add(minMaxTemp);
            filterList.Add(sunriseSunset);
            filterList.Add(pressure);
            filterList.Add(humidity);
            filterList.Add(wind);

            return filterList;
        }

        private DataTable GetImportedWeather(int Id)
        {
            DataTable dataTable = new DataTable();
            SqlCommand sqlComm = GetConnectionString("GetCityWeather");
            sqlComm.Parameters.Add("@id", SqlDbType.Int);
            sqlComm.Parameters["@id"].Value = Id;
            try
            {
                using (sqlComm.Connection)
                {
                    using (sqlComm)
                    {
                        SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlComm);
                        sqlComm.Connection.Open();
                        sqlDataAdapter.Fill(dataTable);
                        return dataTable;
                    }
                }
            }
            catch (SqlException sqlException)
            {
                throw sqlException;
            }
        }

        private TimeSpan CheckLastPullDateTime(DataTable dataTable)
        {
            DateTime lastPullDateTime = new DateTime();
            for (int rowIndex = 0; rowIndex < dataTable.Rows.Count; rowIndex++) {
                lastPullDateTime = Convert.ToDateTime(dataTable.Rows[rowIndex]["LastPullDateTime"].ToString());
            }
            TimeSpan timeSpan = DateTime.Now - lastPullDateTime;
            return timeSpan;
        }

        private void ImportWeather(int Id)
        {
            SqlCommand sqlComm = GetConnectionString("ImportCityWeather");
            sqlComm.Parameters.Add("@id", SqlDbType.Int);
            sqlComm.Parameters.Add("@json", SqlDbType.NVarChar);
            sqlComm.Parameters["@id"].Value = Id;
            sqlComm.Parameters["@json"].Value = GetWeather(Id);

            try
            {
                using (sqlComm.Connection)
                {
                    using (sqlComm)
                    {
                        sqlComm.Connection.Open();
                        sqlComm.ExecuteNonQuery();
                    }

                }

            }
            catch (SqlException sqlException)
            {
                throw sqlException;
            }
        }

        private string GetWeather(int Id)
        {
            Uri uri = new Uri(@"http://api.openweathermap.org/data/2.5/weather?id=" + Id + "&appid=1ed3d8bfc8e69fe101e4038147552880");
            WebRequest webRequest = WebRequest.Create(uri);
            WebResponse webResponse = webRequest.GetResponse();
            StreamReader streamReader = new StreamReader(webResponse.GetResponseStream());
            String responseData = streamReader.ReadToEnd();
            return responseData;
        }

        private string FormatWeather(List<string> filterList, DataTable dataTable)
        {
                string weatherFormat = String.Empty;

                for (int filterIndex = 0; filterIndex < filterList.Count; filterIndex++)
                {
                    if (filterList[filterIndex] != string.Empty)
                    {
                        string[] filterArray = filterList[filterIndex].Split(',');
                        if (dataTable.Rows.Count > 0)
                        {
                            for (int filterArrayIndex = 0; filterArrayIndex < filterArray.Length; filterArrayIndex++)
                            {
                                weatherFormat += dataTable.Columns[filterArray[filterArrayIndex].Trim()].ColumnName + ": " + dataTable.Rows[0][filterArray[filterArrayIndex].Trim()].ToString() + "<br>";
                            }
                        }
                    }
                }
                return weatherFormat;
        }
   }
}
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Capa_Datos
{
    public class CD_PROCEDIMIENTOS
    {
        CD_CONEXION CX = new CD_CONEXION();

        DataTable DT = new DataTable();
        SqlCommand CMD = new SqlCommand();
        SqlDataReader DR;

        public DataTable LlenarDataGrid(string tabla)
        {
            DT = new DataTable();
            CMD = new SqlCommand(tabla, CX.ABRIR());
            DR = CMD.ExecuteReader();
            DT.Load(DR);


            return DT;


        }
    }
}

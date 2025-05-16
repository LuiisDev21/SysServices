using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using Capa_Datos;


namespace Capa_Negocio  
{
    public class CN_CHECKDB
    {
        CD_CONEXION CX = new CD_CONEXION();
        public string Db_Intent_Connection()
        {
            try
            {
                {
                    CX.ABRIR();
                    return "ok";
                }
            }
            catch (Exception)
            {
                return "fail";
            }
        }
    }

}



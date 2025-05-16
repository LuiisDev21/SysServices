using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Capa_Datos;

namespace Capa_Negocio
{
    public class CN_INICIOSESION
    {
        CD_CONEXION CX = new CD_CONEXION();

        public string ValidarUsuario(string user, string pass)
        {
            string _Consulta = $"SELECT COUNT(1) FROM Tbl_Admins WHERE Usuario='{user}' AND UserPass='{pass}'";
  
            {
                SqlCommand Ejecutar = new SqlCommand(_Consulta, CX.ABRIR());
                int _Resultado = (int)Ejecutar.ExecuteScalar();

                if (_Resultado == 1)
                {
                    return "Success";
                }
                else
                {
                    return "Fail";
                }
            }
        }
    }
}

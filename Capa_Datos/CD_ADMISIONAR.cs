using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Capa_Entidad;

namespace Capa_Datos
{
    public class CD_ADMISIONAR
    {
        CD_CONEXION CX = new CD_CONEXION();
        SqlCommand CMD = new SqlCommand();

        public void InsertarAdmision(CE_MPACIENTE MP)
        {
            CMD = new SqlCommand("GuardarAdmision", CX.ABRIR());
            CMD.CommandType = CommandType.StoredProcedure;
            CMD.Parameters.AddWithValue("@Numero_Inss", MP.Inss_paciente);
            CMD.Parameters.AddWithValue("@Id_Especialidad", MP.Id_especialidad);
            CMD.Parameters.AddWithValue("@Observacion", MP.Observacion);
            CMD.Parameters.AddWithValue("@Id_Admin", MP.Id_admin);

            CMD.ExecuteNonQuery();
            CX.CERRAR();
        }


    }
}

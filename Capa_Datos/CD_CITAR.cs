using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Capa_Entidad;
using System.Data.SqlClient;
using System.Data;

namespace Capa_Datos
{
    public class CD_CITAR
    {
        CD_CONEXION CX = new CD_CONEXION();
        SqlCommand CMD = new SqlCommand();

        public void InsertarCita(CE_MPACIENTE MC)
        {
            CMD = new SqlCommand("InsertarCita", CX.ABRIR());
            CMD.CommandType = CommandType.StoredProcedure;
            CMD.Parameters.AddWithValue("@Numero_Inss", MC.Inss_paciente);
            CMD.Parameters.AddWithValue("@Id_Especialidad", MC.Id_especialidad);
            CMD.Parameters.AddWithValue("@Fecha_Cita", MC.Fecha_cita);
            CMD.Parameters.AddWithValue("@Observacion", MC.Observacion);
            CMD.Parameters.AddWithValue("@Id_Admin", MC.Id_admin);
            
            CMD.ExecuteNonQuery();
            CX.CERRAR();
        }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Capa_Entidad
{
    public class CE_MPACIENTE
    {
        private string _inss_paciente;
        private string _id_especialidad;
        private string _observacion;
        private string _id_admin;
        private DateTime _fecha_cita;

        public string Inss_paciente { get => _inss_paciente; set => _inss_paciente = value; }
        public string Id_especialidad { get => _id_especialidad; set => _id_especialidad = value; }
        public string Observacion { get => _observacion; set => _observacion = value; }
        public string Id_admin { get => _id_admin; set => _id_admin = value; }
        public DateTime Fecha_cita { get => _fecha_cita; set => _fecha_cita = value; }
    }
}

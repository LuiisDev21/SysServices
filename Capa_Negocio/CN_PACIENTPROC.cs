using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Capa_Datos;
using Capa_Entidad;

namespace Capa_Negocio
{
    public class CN_PACIENTPROC
    {
        CD_ADMISIONAR objPaciente = new CD_ADMISIONAR();
        CD_CITAR objCita = new CD_CITAR();

        public void InsertarAdmision(CE_MPACIENTE MP)
        {
            objPaciente.InsertarAdmision(MP);

        }


        public void InsertarCita(CE_MPACIENTE MC)
        {
            objCita.InsertarCita(MC);
        }
    }
}

using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Capa_Datos;

namespace Capa_Negocio
{
    
    public class CN_PROCEDIMIENTOS
    {
        CD_PROCEDIMIENTOS PROC = new CD_PROCEDIMIENTOS();
        public DataTable ObtenerData(string procedure)
        {
            return PROC.LlenarDataGrid(procedure);
        }
    }
}

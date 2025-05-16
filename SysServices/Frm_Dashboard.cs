using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using BunifuAnimatorNS;
using System.Runtime.InteropServices;
using Capa_Negocio;
using Capa_Entidad;

// ______________________
// PROGRAMACION ORIENTADA A OBJETOS | GRUPO: DI10A
// Proyecto SysServices, sistema hospitalario de admision y citas
// ______________________



namespace SysServices
{
    

public partial class Frm_Dashboard : Form
    {

        CN_PROCEDIMIENTOS PROC = new CN_PROCEDIMIENTOS();
        CE_MPACIENTE CE = new CE_MPACIENTE();
        CN_PACIENTPROC CN = new CN_PACIENTPROC();

        private Timer timer;
        public string Username { get; set; }

   
        public Frm_Dashboard(string username)
        {
            InitializeComponent();
            InitializeTimer();
            Username = username;
            LB_UserStatus.Text = $"{Username}@AdmisionPC1";
            PNL_DashMain.MouseDown += new MouseEventHandler(PNL_DashMain_MouseDown);
            LoadAdmisiones();
            FuncMaximizar.Activar(this);
        }


        [DllImport("user32.dll")]
        public static extern int SendMessage(IntPtr hWnd, int Msg, int wParam, int lParam);
        [DllImport("user32.dll")]
        public static extern bool ReleaseCapture();


        // Permite mover la ventana
        private void PNL_DashMain_MouseDown(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                ReleaseCapture();
                SendMessage(this.Handle, 0xA1, 0x2, 0);
            }
        }

        // Inicializa el temporizador
        private void InitializeTimer()
        {
            timer = new Timer();
            timer.Interval = 1000;
            timer.Tick += new EventHandler(UpdateClock);
            timer.Start();
        }

        // Actualiza el reloj en la interfaz
        private void UpdateClock(object sender, EventArgs e)
        {
            LB_DashTime.Text = DateTime.Now.ToString("hh:mm:ss tt");
        }

        // Cierra la aplicación
        private void BTN_Close_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        // Minimiza la ventana
        private void BTN_Minimize_Click_1(object sender, EventArgs e)
        {
            this.WindowState = FormWindowState.Minimized;
        }

        // Maximiza la ventana
        private void BTN_Maximize_Click(object sender, EventArgs e)
        {
            FuncMaximizar.Activar(this);
        }

        // Carga las admisiones en el DataGridView
        private void LoadAdmisiones()
        {
            DGV_ADMISIONES.DataSource = PROC.ObtenerData("ListarAdmisiones");
        }

        // Carga los datos del paciente
        private void CargarPaciente()
        {
            string id = TB_InputInss.Text;
            if (string.IsNullOrEmpty(id))
            {
                MessageBox.Show("Debes insertar un INSS valido", "Advertencia", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            DataTable dt = PROC.ObtenerData("BuscarPaciente " + id);
            if (dt.Rows.Count == 0)
            {
                MessageBox.Show("No se encontraron coincidencias.", "Información", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
            else
            {
                DGV_PACIENTE.DataSource = dt;
            }
        }

        // Carga los datos del paciente para citas
        private void CargarPacienteCita()
        {
            string id = TB_INSS.Text;
            if (string.IsNullOrEmpty(id))
            {
                MessageBox.Show("Debes insertar un INSS valido", "Advertencia", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            DataTable dt = PROC.ObtenerData("BuscarPaciente " + id);
            if (dt.Rows.Count == 0)
            {
                MessageBox.Show("No se encontraron coincidencias.", "Información", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
            else
            {
                DGV_PACIENTECITA.DataSource = dt;
            }
        }

        // Carga las admisiones del paciente
        private void CargarAdmisionesPaciente()
        {
            string id = TB_InputInss.Text;
            if (string.IsNullOrEmpty(id))
            {
                DGV_ADMISIONESPACIENTE.DataSource = null;
                DGV_ADMISIONESPACIENTE.BackgroundColor = Color.LightGray;
            }
            else
            {
                DataTable dt = PROC.ObtenerData("AdmisionesPaciente " + id);
                if (dt.Rows.Count == 0)
                {
                    DGV_ADMISIONESPACIENTE.DataSource = null;
                    DGV_ADMISIONESPACIENTE.BackgroundColor = Color.LightGray;
                }
                else
                {
                    DGV_ADMISIONESPACIENTE.DataSource = dt;
                }
            }
        }

        // Carga el historial de citas del paciente
        private void CargarCitasPaciente()
        {
            string id = TB_INSSCT.Text;
            if (string.IsNullOrEmpty(id))
            {
                DGV_HISTCITA.DataSource = null;
                DGV_HISTCITA.BackgroundColor = Color.LightGray;
            }
            else
            {
                DataTable dt = PROC.ObtenerData("HistorialCitas " + id);
                if (dt.Rows.Count == 0)
                {
                    DGV_HISTCITA.DataSource = null;
                    DGV_HISTCITA.BackgroundColor = Color.LightGray;
                }
                else
                {
                    DGV_HISTCITA.DataSource = dt;
                }
            }
        }

        // Carga las citas del paciente
        private void AdmCargarCitasPaciente()
        {
            string id = TB_InputInss.Text;
            if (string.IsNullOrEmpty(id))
            {
                DGV_CITASDELPACIENTE.DataSource = null;
                DGV_CITASDELPACIENTE.BackgroundColor = Color.LightGray;
            }
            else
            {
                DataTable dt = PROC.ObtenerData("HistorialCitas " + id);
                if (dt.Rows.Count == 0)
                {
                    DGV_CITASDELPACIENTE.DataSource = null;
                    DGV_CITASDELPACIENTE.BackgroundColor = Color.LightGray;
                }
                else
                {
                    DGV_CITASDELPACIENTE.DataSource = dt;
                }
            }
        }

        // Procesa la tecla F5 para recargar admisiones
        protected override bool ProcessCmdKey(ref Message msg, Keys keyData)
        {
            if (keyData == Keys.F5)
            {
                LoadAdmisiones();
                return true;
            }
            return base.ProcessCmdKey(ref msg, keyData);
        }

        // Botón para buscar paciente y cargar datos
        private void BTN_Buscar_Click(object sender, EventArgs e)
        {
            CargarPaciente();
            CargarAdmisionesPaciente();
            AdmCargarCitasPaciente();
        }

        // Botón para realizar una admisión
        private void BTN_ADMISIONAR_Click(object sender, EventArgs e)
        {
            if (CB_ESPECIALIDADES.SelectedIndex == 0)
            {
                MessageBox.Show("Debe seleccionar una especialidad válida.", "Advertencia", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            DialogResult result = MessageBox.Show("¿Está seguro de que desea realizar esta admisión?", "Confirmar Admisión", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
            if (result == DialogResult.Yes)
            {
                CE.Inss_paciente = TB_InputInss.Text;
                CE.Id_especialidad = CB_ESPECIALIDADES.SelectedIndex.ToString();
                CE.Observacion = TB_OBSERVACION.Text;
                CE.Id_admin = 1.ToString();

                CN.InsertarAdmision(CE);

                MessageBox.Show("Admision realizada con éxito", "Información", MessageBoxButtons.OK, MessageBoxIcon.Information);

                TB_InputInss.Clear();
                DGV_ADMISIONESPACIENTE.DataSource = null;
                DGV_PACIENTE.DataSource = null;
                DGV_CITASDELPACIENTE.DataSource = null;
            }
        }

        // Botón para guardar una cita
        private void BTN_GUARDARCITA_Click(object sender, EventArgs e)
        {
            if (CB_ESPCITA.SelectedIndex == 0)
            {
                MessageBox.Show("Debe seleccionar una especialidad válida.", "Advertencia", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            DialogResult result = MessageBox.Show("¿Está seguro de que desea agendar esta cita?", "Confirmar Cita", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
            if (result == DialogResult.Yes)
            {
                CE.Inss_paciente = TB_INSS.Text;
                CE.Id_especialidad = CB_ESPCITA.SelectedIndex.ToString();
                CE.Fecha_cita = DTP_FECHACITA.Value;
                CE.Observacion = TB_OBSCITA.Text;
                CE.Id_admin = 1.ToString();

                CN.InsertarCita(CE);

                MessageBox.Show("Cita guardada con éxito", "Información", MessageBoxButtons.OK, MessageBoxIcon.Information);

                TB_INSS.Clear();
                TB_OBSCITA.Clear();
                DTP_FECHACITA.Value = DateTime.Now;
                CB_ESPCITA.SelectedIndex = 0;

                DGV_PACIENTECITA.DataSource = null;
            }
        }

        // Botón para buscar paciente para cita
        private void BTN_BPACIENTECITA_Click(object sender, EventArgs e)
        {
            CargarPacienteCita();
        }

        // Filtra las admisiones en el DataGridView
        private void TB_BUSCADOR_TextChanged_1(object sender, EventArgs e)
        {
            (DGV_ADMISIONES.DataSource as DataTable).DefaultView.RowFilter = string.Format("CONVERT(Numero_Admision, 'System.String') LIKE '%{0}%' OR Nombre_Completo LIKE '%{0}%'", TB_BUSCADOR.Text);
        }

        // Botón para buscar citas del paciente
        private void BTN_BUSCARCITAPA_Click(object sender, EventArgs e)
        {
            CargarCitasPaciente();
        }
    }
}


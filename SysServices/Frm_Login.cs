using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Capa_Negocio;

namespace SysServices
{
    public partial class Frm_Login : Form
    {
        public Frm_Login()
        {
            InitializeComponent();
            Check_DB();
            this.AcceptButton = BTN_LoginButton;
        }

        private void Check_DB()
        {
            CN_CHECKDB Connection_Intent = new CN_CHECKDB();
            string _Result = Connection_Intent.Db_Intent_Connection();
            if (_Result == "ok")
            {
                LB_DbStatus.Text = "Online ✅";
                TB_Username.Focus();
            }
            else
            {
                LB_DbStatus.Text = "Db Connection Failed 🚫";
                TB_Username.Enabled = false;
                TB_Password.Enabled = false;
                LB_DbAlert.Visible = true;
            }
        }

        private void LoginUser()
        {
            CN_INICIOSESION login = new CN_INICIOSESION();
            string user = TB_Username.Text;
            string pass = TB_Password.Text;
            string IntentarLogin = login.ValidarUsuario(user, pass);
            if (TB_Username.Text == string.Empty || TB_Password.Text == string.Empty)
            {
                MessageBox.Show("Por favor, rellene todos los campos", "Error", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            }
            else
            {
                if (IntentarLogin == "Success")
                {
                    Frm_Dashboard dashboard = new Frm_Dashboard(TB_Username.Text);
                    dashboard.Show();
                    this.Hide();
                }
                else
                {
                    MessageBox.Show($"Usuario o contraseña incorrectos", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    TB_Password.Clear();
                }
            }
        }

        private void BTN_LoginButton_Click(object sender, EventArgs e)
        {
            LoginUser();
        }

        private void BTN_Minimize_Click(object sender, EventArgs e)
        {
            this.WindowState = FormWindowState.Minimized;
        }

        private void BTN_Close_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void bunifuSeparator1_Click(object sender, EventArgs e)
        {

        }
    }
}

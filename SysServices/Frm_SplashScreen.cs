using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace SysServices
{
    public partial class SplashScreen : Form
    {
        public SplashScreen()
        {
            InitializeComponent();
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            timer1.Enabled = true;
            pbSplash.Value += 5;
            if (pbSplash.Value == 100)
            {
                timer1.Enabled = false;
                this.Hide();
                Frm_Login login = new Frm_Login();
                login.Show();
            }
        }
    }
}

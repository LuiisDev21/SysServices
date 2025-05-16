using System;
using System.Collections.Generic;
using System.Drawing;
using System.Windows.Forms;

public static class FuncMaximizar
{
    private class EstadoFormulario
    {
        public bool _EstaMaximizado { get; set; }
        public FormBorderStyle _BordeOriginal { get; set; }
        public Point _UbicacionOriginal { get; set; }
        public Size _TamanoOriginal { get; set; }
        public FormWindowState _EstadoVentanaOriginal { get; set; }
    }

    private static Dictionary<Form, EstadoFormulario> _estadosFormulario = new Dictionary<Form, EstadoFormulario>();

    public static void Activar(Form _formulario)
    {
        if (_formulario == null)
            throw new ArgumentNullException(nameof(_formulario));

        if (!_estadosFormulario.ContainsKey(_formulario))
            _estadosFormulario[_formulario] = new EstadoFormulario { _EstaMaximizado = false };

        var _estado = _estadosFormulario[_formulario];

        if (!_estado._EstaMaximizado)
        {
            _estado._BordeOriginal = _formulario.FormBorderStyle;
            _estado._UbicacionOriginal = _formulario.Location;
            _estado._TamanoOriginal = _formulario.Size;
            _estado._EstadoVentanaOriginal = _formulario.WindowState;

            _formulario.FormBorderStyle = FormBorderStyle.None;
            _formulario.StartPosition = FormStartPosition.Manual;
            _formulario.Location = new Point(0, 0);
            _formulario.Size = Screen.PrimaryScreen.WorkingArea.Size;
            _estado._EstaMaximizado = true;
        }
        else
        {
            _formulario.FormBorderStyle = _estado._BordeOriginal;
            _formulario.Location = _estado._UbicacionOriginal;
            _formulario.Size = _estado._TamanoOriginal;
            _formulario.WindowState = _estado._EstadoVentanaOriginal;
            _estado._EstaMaximizado = false;
        }
    }
}

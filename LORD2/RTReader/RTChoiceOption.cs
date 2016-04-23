using System;
using System.Collections.Generic;
using System.Text;

namespace LORD2
{
    public class RTChoiceOption
    {
        public string Text;
        public bool Visible;
        public int VisibleIndex;

        public RTChoiceOption(string text)
        {
            Text = text;
            Visible = true;
            VisibleIndex = 0;
        }
    }
}

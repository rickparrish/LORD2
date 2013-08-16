using System;
using System.Collections.Generic;
using System.Text;

namespace LORD2
{
    class RTRFile
    {
        public Dictionary<string, RTRSection> Sections;

        public RTRFile()
        {
            Sections = new Dictionary<string, RTRSection>(StringComparer.OrdinalIgnoreCase);
        }
    }
}

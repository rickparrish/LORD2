using System;
using System.Collections.Generic;
using System.Text;

namespace LORD2
{
    public class RTRefFile
    {
        public string Name;
        public Dictionary<string, RTRefSection> Sections;

        public RTRefFile(string name)
        {
            Name = name;
            Sections = new Dictionary<string, RTRefSection>(StringComparer.OrdinalIgnoreCase);
        }
    }
}

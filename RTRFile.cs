using System;
using System.Collections.Generic;
using System.Text;

namespace LORD2
{
    public class RTRFile
    {
        public string Name;
        public Dictionary<string, RTRSection> Sections;

        public RTRFile(string name)
        {
            Name = name;
            Sections = new Dictionary<string, RTRSection>(StringComparer.OrdinalIgnoreCase);
        }
    }
}

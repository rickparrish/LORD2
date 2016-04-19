using System;
using System.Collections.Generic;
using System.Text;

namespace LORD2
{
    public class RTRefSection
    {
        public Dictionary<string, int> Labels;
        public string Name;
        public List<string> Script;

        public RTRefSection(string name)
        {
            Labels = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
            Name = name;
            Script = new List<string>();
        }
    }
}

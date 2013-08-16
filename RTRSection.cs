using System;
using System.Collections.Generic;
using System.Text;

namespace LORD2
{
    public class RTRSection
    {
        public Dictionary<string, int> Labels;
        public List<string> Script;

        public RTRSection()
        {
            Labels = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
            Script = new List<string>();
        }
    }
}

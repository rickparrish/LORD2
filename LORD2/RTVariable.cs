using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LORD2
{
    public class RTVariable
    {
        public Func<string, string> Get = null;
        public Action<string> Set = null;

        public RTVariable(Func<string, string> get, Action<string> set)
        {
            this.Get = get;
            this.Set = set;
        }
    }
}

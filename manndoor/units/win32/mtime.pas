unit mTime;

interface

uses
  Windows;

function TimeZoneBias: LongInt;
function UnixTimeToDateTime(ATime: Double): Double;

implementation

{
  Returns the number of minutes between UTC and the current local time
}
function TimeZoneBias: LongInt;
var
  Res: LongInt;
  TZI: TTimeZoneInformation;
begin
     Res := GetTimeZoneInformation(TZI);
     if (Res = TIME_ZONE_ID_STANDARD) then
        TimeZoneBias := TZI.Bias + TZI.StandardBias
     else
     if (Res = TIME_ZONE_ID_DAYLIGHT) then
        TimeZoneBias := TZI.Bias + TZI.DaylightBias
     else
         TimeZoneBias := 0;
end;

{
  Convert a unix time stamp to a DateTime value

          Unix = Seconds since 01/01/1970 00:00:00 GMT
      DateTime = Days since 30/12/1899 00:00:00 in local timezone
       / 86400 = Turn "seconds since" into "days since"
      365 * 70 = Make up for 70 year difference
          + 17 = Number of leap years in those 70 years
           + 2 = Make 30/12 into 01/01
  - TZB / 1440 = Put into local timezone
}
function UnixTimeToDateTime(ATime: Double): Double;
begin
     UnixTimeToDateTime := (ATime / 86400) + (365 * 70 + 17 + 2) - (TimeZoneBias / 1440);
end;

end.

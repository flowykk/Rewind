namespace RewindApp.Extensions;

public static class Extensions
{
    public static IEnumerable<T> Shuffle<T>(this IEnumerable<T> source)
    {
        var rng = new Random();

        var buffer = source.ToList();
        var n = buffer.Count;
        while (n > 1)
        {
            n--;
            var k = rng.Next(n + 1);
            (buffer[k], buffer[n]) = (buffer[n], buffer[k]);
        }
        return buffer;
    }
}
using Microsoft.EntityFrameworkCore;
using Org.BouncyCastle.Tls;
using RewindApp.Data;

namespace RewindApp.Tests;

public static class ContextGenerator
{
    public static DataContext Generate()
    {
        var optionsBuilder = new DbContextOptionsBuilder<DataContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString());
        return new DataContext(optionsBuilder.Options);
    }
}
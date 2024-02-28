using Microsoft.EntityFrameworkCore;
using RewindApp.Entities;

namespace RewindApp.Data;

public class DataContext : DbContext
{
    public DataContext(DbContextOptions<DataContext> options) : base(options)
    {
    }

    private static string server = "localhost";
    private static string databaseName = "rewinddb";
    private static string userName = "rewinduser";
    private static string password = "rewindpass";

    public static readonly string connection =
        $"Server={server}; database={databaseName}; UID={userName}; password={password}";

    public DbSet<User> Users => Set<User>();
    public DbSet<Group> Groups => Set<Group>(); 
    public DbSet<Media> Media => Set<Media>();
}
using System.Data.Common;
using Microsoft.EntityFrameworkCore;
using MySql.Data.MySqlClient;
using RewindApp.Entities;
using RewindApp.Views;

namespace RewindApp.Data;

public class DataContext : DbContext
{
    public DataContext(DbContextOptions<DataContext> options) : base(options)
    {
    }

    public static string GetDbConnection()
    {
        const string server = "localhost";
        const string databaseName = "rewinddb";
        const string userName = "rewinduser";
        const string password = "rewindpass";

        return $"Server={server}; Port=3306; Database={databaseName}; UID={userName}; Pwd={password}";
    }
    
    public DbSet<User> Users => Set<User>();
    public DbSet<Group> Groups => Set<Group>(); 
    public DbSet<Media> Media => Set<Media>();
    public DbSet<MediaView> MediaViews => Set<MediaView>();
    public DbSet<UserView> UserViews => Set<UserView>();
    public DbSet<Tag> Tags => Set<Tag>();
}
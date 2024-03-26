using MySql.Data.MySqlClient;
using RewindApp.Data;

namespace RewindApp.Services;

public class SqlService
{
    public void UpdateInfo(string commandText, List<MySqlParameter> parameters)
    {
        var connectionString = DataContext.GetDbConnection();
        var connection = new MySqlConnection(connectionString);
        connection.Open();
        
        var command = new MySqlCommand()
        {
            Connection = connection,
            CommandText = commandText
        };

        foreach (var param in parameters) command.Parameters.Add(param);
        command.ExecuteNonQuery();
    }
}
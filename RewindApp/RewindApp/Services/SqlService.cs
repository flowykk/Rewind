using MySql.Data.MySqlClient;
using RewindApp.Data;
using RewindApp.Entities;

namespace RewindApp.Services;

public class SqlService
{
    private void RunCommand(string commandText, List<MySqlParameter> parameters)
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

    public void UpdateUserImage(User user)
    {
        var imageParameter = new MySqlParameter("?objectData", MySqlDbType.Blob, user.ProfileImage.Length)
        {
            Value = user.ProfileImage
        };
        var tinyImageParameter = new MySqlParameter("?tinyObjectData", MySqlDbType.Blob, user.TinyProfileImage.Length)
        {
            Value = user.TinyProfileImage
        };
        var idParameter = new MySqlParameter("?userId", MySqlDbType.Int64)
        {
            Value = user.Id
        };

        const string commandText = "UPDATE Users SET ProfileImage = @objectData, TinyProfileImage = @tinyObjectData WHERE Id = @userId;";
        var parameters = new List<MySqlParameter>
        {
            imageParameter,
            tinyImageParameter,
            idParameter
        };

        RunCommand(commandText, parameters);
    }


    public void UpdateGroupImage(Group group)
    {
        var imageParameter = new MySqlParameter("?objectData", MySqlDbType.Blob, group.Image.Length)
        {
            Value = group.Image
        };
        var tinyImageParameter = new MySqlParameter("?tinyObjectData", MySqlDbType.Blob, group.TinyImage.Length)
        {
            Value = group.TinyImage
        };
        var groupIdParameter = new MySqlParameter("?groupId", MySqlDbType.Int64)
        {
            Value = group.Id
        };

        const string commandText = "UPDATE Groups SET Image = @objectData, TinyImage = @tinyObjectData WHERE Id = @groupId;";
        var parameters = new List<MySqlParameter>
        {
            imageParameter,
            tinyImageParameter,
            groupIdParameter
        };
        
        RunCommand(commandText, parameters);
    }

    public void Delete(int firstId, int secondId, string firstIdName, string secondIdName, string table)
    {
        var firstIdParameter = new MySqlParameter("?firstId", MySqlDbType.Int64)
        {
            Value = firstId
        };
        var secondIdParameter = new MySqlParameter("?secondId", MySqlDbType.Int64)
        {
            Value = secondId
        };

        var commandText = $"DELETE FROM {table} WHERE {firstIdName} = @firstId AND {secondIdName} = @secondId;";
        var parameters = new List<MySqlParameter>
        {
            firstIdParameter,
            secondIdParameter
        };
        
        RunCommand(commandText, parameters);
    } 
}
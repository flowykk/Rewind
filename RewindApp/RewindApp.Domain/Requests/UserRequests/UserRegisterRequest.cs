using System.ComponentModel.DataAnnotations;

namespace RewindApp.Domain.Requests.UserRequests;

public class UserRegisterRequest
{
    [Required] public string UserName { get; set; } = string.Empty;
    
    [Required, EmailAddress] public string Email { get; set; } = string.Empty;
    
    [Required] public string Password { get; set; } = string.Empty;
    
}
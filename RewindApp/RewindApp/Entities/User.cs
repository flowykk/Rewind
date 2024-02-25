using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace RewindApp.Entities;

public class User
{
    [Key]
    public int UsersId { get; set; }
    [Required, MaxLength(128)]
    public string UserName { get; set; } = string.Empty;
    [Required, MaxLength(128)]
    public string Email { get; set; } = string.Empty;
    [Required, MaxLength(128)]
    public string Password { get; set; } = string.Empty;
    [Required]
    public DateTime RegistrationDateTime { get; set; } = DateTime.Now;
    [Required]
    public byte[] ProfileImage { get; set; } = Array.Empty<byte>();

    public ICollection<Group> Groups { get; set; } = new List<Group>();
}
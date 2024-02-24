using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace RewindApp.Models;

[Keyless]
public class GroupMembers
{
    [ForeignKey(nameof(User))]
    public int UserId { get; set; }
    [ForeignKey(nameof(Groups))]
    public int GroupId { get; set; }
}
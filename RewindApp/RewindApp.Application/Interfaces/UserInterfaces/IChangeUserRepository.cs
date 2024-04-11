using Microsoft.AspNetCore.Mvc;
using RewindApp.Domain.Entities;
using RewindApp.Domain.Requests;
using RewindApp.Domain.Requests.ChangeRequests;

namespace RewindApp.Application.Interfaces.UserInterfaces;

public interface IChangeUserRepository
{
    Task ChangeNameAsync(User user, TextRequest request);
    Task ChangeEmailAsync(User user, EmailRequest request);
    Task ChangePasswordAsync(User user, PasswordRequest request);
    Task ChangeAppIconAsync(User user, string newIcon);
    Task ChangeProfileImage(User user, MediaRequest mediaRequest);
}
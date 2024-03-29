using Microsoft.AspNetCore.Mvc;
using RewindApp.Entities;
using RewindApp.Requests;
using RewindApp.Requests.ChangeRequests;

namespace RewindApp.Interfaces.UserInterfaces;

public interface IChangeUserRepository
{
    Task<User> ChangeNameAsync(User user, int userId, TextRequest request);
    Task<User> ChangeEmailAsync(User user, int userId, EmailRequest request);
    Task<User> ChangePasswordAsync(User user, int userId, PasswordRequest request);
    Task<User> ChangeProfileImage(User user, int userId, MediaRequest mediaRequest);
}
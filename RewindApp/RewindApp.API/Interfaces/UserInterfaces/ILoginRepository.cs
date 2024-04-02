using Microsoft.AspNetCore.Mvc;
using RewindApp.Entities;
using RewindApp.Requests.UserRequests;

namespace RewindApp.Interfaces.UserInterfaces;

public interface ILoginRepository
{
    int CheckEmail(string email);
    Task<User> Login(UserLoginRequest request);
}
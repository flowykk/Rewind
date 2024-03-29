using AutoFixture;
using RewindApp.Requests;
using RewindApp.Requests.ChangeRequests;
using RewindApp.Requests.UserRequests;

namespace RewindApp.Tests;

public static class ContextHelper
{
    private static Fixture _fixture = new Fixture();
    public static UserRegisterRequest BuildTestRegisterRequest() 
    {
        return _fixture
            .Build<UserRegisterRequest>()
            .With(req => req.Email, "test@test.test")
            .With(req => req.Password, "ee26b0dd4af7e749aa1a8ee3c10ae9923f618980772e473f8819a5d4940e0db27ac185f8a0e1d5f84f88bc887fd67b143732c304cc5fa9ad8e6f57f50028a8ff")
            .Create();
    }
    
    public static UserRegisterRequest BuildExtraUserRegisterRequest()//int extraUserId) 
    {
        return _fixture
            .Build<UserRegisterRequest>()
            //.With(req => req.Id, extraUserId)
            .Create();
    }
    
    public static UserLoginRequest BuildTestLoginRequest() 
    {
        return _fixture
            .Build<UserLoginRequest>()
            .With(req => req.Email, "test@test.test")
            .With(req => req.Password, "test")
            .Create();
    }
    
    public static UserLoginRequest BuildInvalidEmailLoginRequest() 
    {
        return _fixture
            .Build<UserLoginRequest>()
            .With(req => req.Email, "no@no.no")
            .With(req => req.Password, "test")
            .Create();
    }
    
    public static UserLoginRequest BuildInvalidPasswordLoginRequest() 
    {
        return _fixture
            .Build<UserLoginRequest>()
            .With(req => req.Email, "test@test.test")
            .With(req => req.Password, "no")
            .Create();
    }

    public static CreateGroupRequest BuildInvalidOwnerIdCreateGroupRequest()
    {
        return _fixture
            .Build<CreateGroupRequest>()
            .With(req => req.OwnerId, 2)
            .With(req => req.GroupName, "defaultName")
            .Create();
    }
    
    public static CreateGroupRequest BuildTestCreateGroupRequest()
    {
        return _fixture
            .Build<CreateGroupRequest>()
            .With(req => req.OwnerId, 1)
            .With(req => req.GroupName, "defaultName")
            .Create();
    }

    public static MediaRequest BuildTestChangeImageRequest()
    {
        return _fixture
            .Build<MediaRequest>()
            .With(req => req.Object, "VGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIDEzIGxhenkgZG9ncy4=")
            .With(req => req.TinyObject, "VGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIDEzIGxhenkgZG9ncy4=")
            .Create();
    }
    
    public static LoadMediaRequest BuildLoadMediaRequest()
    {
        return _fixture
            .Build<LoadMediaRequest>()
            .With(req => req.Object, "VGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIDEzIGxhenkgZG9ncy4=")
            .With(req => req.TinyObject, "VGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIDEzIGxhenkgZG9ncy4=")
            .With(req => req.IsPhoto, 1)
            .With(req => req.Tags, new List<string>())
            .Create();
    }
    
    public static TextRequest BuildDefaultNameRequest()
    {
        return _fixture.Create<TextRequest>();
    }
    
    public static TextRequest BuildNameRequest(string name)
    {
        return _fixture
            .Build<TextRequest>()
            .With(req => req.Text, name)
            .Create();
    }
}
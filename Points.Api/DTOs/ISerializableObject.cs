namespace Points.Api.DTOs
{
    public interface ISerializableObject
    {
        string GetPrimaryPropertyName();
        Type GetPrimaryPropertyType();
    }
}

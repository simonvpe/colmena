{ self, ... }:
# recommend using `hashedPassword`
{
  users.users.root.hashedPassword = "$6$WjQs8n.Ibo$y7lNx0OBkJi2O2gTO64BHbLfhsHIbXz3xOq0qbBuzUmVZRRVimyR7xJ0oQDGh0QgS0nWo/Iud4GTrUaFyHfOd/";
}

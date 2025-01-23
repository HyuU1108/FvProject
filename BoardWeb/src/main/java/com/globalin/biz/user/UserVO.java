package com.globalin.biz.user;

public class UserVO {
    private String id;
    private String password;
    private String name;
    private String role;

    // getter 및 setter
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

	public String getEmail() {
		return name;
	}

	public void setEmail(String email) {
		this.name = email;
	}

	public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

	public void setName(String string) {
		// TODO Auto-generated method stub
		
	}
}

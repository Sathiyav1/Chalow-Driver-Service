package com.chalow.rideshare.dto;

public class UserDTO {
    public static class UserResponse {
        private Long id;
        private String username;
        public Long getId() { return id; }
        public String getUsername() { return username; }
        public Object getDistancePreference() { return null; }
    }
}

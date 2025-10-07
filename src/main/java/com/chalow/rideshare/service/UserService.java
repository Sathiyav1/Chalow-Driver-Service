package com.chalow.rideshare.service;

import com.chalow.rideshare.dto.UserDTO;
import org.springframework.security.core.Authentication;

import java.util.List;

public interface UserService {
    UserDTO.UserResponse getCurrentUser(Authentication authentication);
    UserDTO.UserResponse getCurrentUserOrCreate(Authentication authentication);
    boolean isNotDriver(UserDTO.UserResponse user);
    boolean isNotAdmin(Authentication authentication);
    void updateUserLocation(Long id, Double lat, Double lon);
    UserDTO.UserResponse findById(Long id);
}

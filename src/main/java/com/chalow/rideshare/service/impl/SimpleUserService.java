package com.chalow.rideshare.service.impl;

import com.chalow.rideshare.dto.UserDTO;
import com.chalow.rideshare.service.UserService;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

@Service
public class SimpleUserService implements UserService {
    @Override
    public UserDTO.UserResponse getCurrentUser(Authentication authentication) { return new UserDTO.UserResponse(); }

    @Override
    public UserDTO.UserResponse getCurrentUserOrCreate(Authentication authentication) { return new UserDTO.UserResponse(); }

    @Override
    public boolean isNotDriver(UserDTO.UserResponse user) { return false; }

    @Override
    public boolean isNotAdmin(Authentication authentication) { return true; }

    @Override
    public void updateUserLocation(Long id, Double lat, Double lon) { }

    @Override
    public UserDTO.UserResponse findById(Long id) { return new UserDTO.UserResponse(); }
}

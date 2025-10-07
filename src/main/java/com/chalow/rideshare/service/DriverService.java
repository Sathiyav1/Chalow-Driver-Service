package com.chalow.rideshare.service;

import com.chalow.rideshare.dto.DriverDTO;

public interface DriverService {
    DriverDTO.DriverProfileResponse getDriverProfile(Long id);
    DriverDTO.DriverProfileResponse updateDriverProfile(Long id, DriverDTO.DriverUpdateRequest request);
}

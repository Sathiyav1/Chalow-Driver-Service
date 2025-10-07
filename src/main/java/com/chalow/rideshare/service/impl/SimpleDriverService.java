package com.chalow.rideshare.service.impl;

import com.chalow.rideshare.dto.DriverDTO;
import com.chalow.rideshare.service.DriverService;
import org.springframework.stereotype.Service;

@Service
public class SimpleDriverService implements DriverService {
    @Override
    public DriverDTO.DriverProfileResponse getDriverProfile(Long id) { return new DriverDTO.DriverProfileResponse(); }

    @Override
    public DriverDTO.DriverProfileResponse updateDriverProfile(Long id, DriverDTO.DriverUpdateRequest request) { return new DriverDTO.DriverProfileResponse(); }
}

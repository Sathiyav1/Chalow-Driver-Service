package com.chalow.rideshare.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "rides")
public class Ride {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "ride_request_id")
    private RideRequest rideRequest;
}

package com.chalow.rideshare.dto;

import org.springframework.data.domain.Page;
import java.util.List;

public class PageResponse<T> {
    private List<T> content;
    private long totalElements;
    private int totalPages;
    public PageResponse() {}
    public PageResponse(List<T> content, Page<?> page) { this.content = content; this.totalElements = page.getTotalElements(); this.totalPages = page.getTotalPages(); }
    public List<T> getContent() { return content; }
}

package com.learn.library_management.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.learn.library_management.entities.Token;

@Repository
public interface TokenRepository extends JpaRepository<Token, Long> {
    Optional<Token> findByToken(String token);
    @Query("""
    	    SELECT t FROM Token t WHERE t.user.id = :userId 
    	""")
    	List<Token> findAllValidTokenByUser(Long userId);
}
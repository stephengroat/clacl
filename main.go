package main

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
)

// RDAP Entity Response
type RdapEntity struct {
	RdapConformance []string `json:"rdapConformance"`
	Notices         []struct {
		Title       string   `json:"title"`
		Description []string `json:"description"`
		Links       []struct {
			Value string `json:"value"`
			Rel   string `json:"rel"`
			Type  string `json:"type"`
			Href  string `json:"href"`
		} `json:"links,omitempty"`
	} `json:"notices"`
	Handle     string `json:"handle"`
	VcardArray []any  `json:"vcardArray"`
	Links      []struct {
		Value string `json:"value"`
		Rel   string `json:"rel"`
		Type  string `json:"type"`
		Href  string `json:"href"`
	} `json:"links"`
	Events []struct {
		EventAction string `json:"eventAction"`
		EventDate   string `json:"eventDate"`
	} `json:"events"`
	Entities []struct {
		Handle     string   `json:"handle"`
		VcardArray []any    `json:"vcardArray"`
		Roles      []string `json:"roles"`
		Links      []struct {
			Value string `json:"value"`
			Rel   string `json:"rel"`
			Type  string `json:"type"`
			Href  string `json:"href"`
		} `json:"links"`
		Events []struct {
			EventAction string `json:"eventAction"`
			EventDate   string `json:"eventDate"`
		} `json:"events"`
		Status          []string `json:"status"`
		Port43          string   `json:"port43"`
		ObjectClassName string   `json:"objectClassName"`
	} `json:"entities"`
	Autnums []struct {
		Handle      string `json:"handle"`
		StartAutnum int    `json:"startAutnum"`
		EndAutnum   int    `json:"endAutnum"`
		Name        string `json:"name"`
		Events      []struct {
			EventAction string `json:"eventAction"`
			EventDate   string `json:"eventDate"`
		} `json:"events"`
		Links []struct {
			Value string `json:"value"`
			Rel   string `json:"rel"`
			Type  string `json:"type"`
			Href  string `json:"href"`
		} `json:"links"`
		Port43          string   `json:"port43"`
		Status          []string `json:"status"`
		ObjectClassName string   `json:"objectClassName"`
	} `json:"autnums"`
	Networks []struct {
		Handle       string `json:"handle"`
		StartAddress string `json:"startAddress"`
		EndAddress   string `json:"endAddress"`
		IPVersion    string `json:"ipVersion"`
		Name         string `json:"name"`
		Type         string `json:"type"`
		ParentHandle string `json:"parentHandle"`
		Events       []struct {
			EventAction string `json:"eventAction"`
			EventDate   string `json:"eventDate"`
		} `json:"events"`
		Links []struct {
			Value string `json:"value"`
			Rel   string `json:"rel"`
			Type  string `json:"type"`
			Href  string `json:"href"`
		} `json:"links"`
		Port43          string   `json:"port43"`
		Status          []string `json:"status"`
		ObjectClassName string   `json:"objectClassName"`
		Cidr0Cidrs      []struct {
			V6Prefix string `json:"v6prefix"`
			Length   int    `json:"length"`
		} `json:"cidr0_cidrs"`
		ArinOriginas0Originautnums []any `json:"arin_originas0_originautnums"`
		Remarks                    []struct {
			Title       string   `json:"title"`
			Description []string `json:"description"`
		} `json:"remarks,omitempty"`
	} `json:"networks"`
	Port43          string `json:"port43"`
	ObjectClassName string `json:"objectClassName"`
}

// Fetch RDAP entity info
func getEntity(entityHandle string) (*RdapEntity, error) {
	url := "https://rdap.arin.net/registry/entity/" + entityHandle
	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	body, _ := io.ReadAll(resp.Body)
	var entity RdapEntity
	err = json.Unmarshal(body, &entity)
	if err != nil {
		return nil, err
	}
	return &entity, err
}

func main() {
	entityHandle := "AUTOM-93"
	entity, err := getEntity(entityHandle)
	if err != nil {
		panic(err)
	}

	for _, network := range entity.Networks {
		fmt.Printf("%s/%d\n", network.StartAddress, network.Cidr0Cidrs[0].Length)
	}
}

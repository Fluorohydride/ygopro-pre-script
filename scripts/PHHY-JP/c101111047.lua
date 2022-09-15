--影の王 レイヴァーテイン
--Script by 奥克斯
local s,id,o=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,2,nil,nil,99)
	c:EnableReviveLimit()
	--decrease atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(-1000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--special summon xyz
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.spcost)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetOverlayCount()
	if chk==0 then return c:IsReleasable() and c:IsSummonType(SUMMON_TYPE_XYZ) end
	Duel.Release(e:GetHandler(),REASON_COST)
	e:SetLabel(ct)
end
function s.filter(c,e,tp,rc)
	return not c:IsRace(RACE_FAIRY) 
		and c:IsSetCard(0x134) and c:IsType(TYPE_XYZ) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,rc,c)>0
end
function s.mtfilter(c,e)
	return  c:IsCanOverlay() and not (e and c:IsImmuneToEffect(e))
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetHandler())
	if #g>0 then
		local tc=g:GetFirst()
		if ct>0 and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0
			and Duel.IsExistingMatchingCard(s.mtfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,tc,e) 
			and tc:IsType(TYPE_XYZ) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local xg=Duel.SelectMatchingCard(tp,s.mtfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,ct,tc,e)
			if #xg>0 then
				local mtg=Group.CreateGroup()
				local tc1=xg:GetFirst()
				while tc1 do
					local og=tc1:GetOverlayGroup()
					if #og>0 then
						Duel.SendtoGrave(og,REASON_RULE)
					end
					mtg:AddCard(tc1)  
					tc1=xg:GetNext()
				end
				if #mtg>0 then
					Duel.Overlay(tc,mtg)
				end
			end
		end
	end
end

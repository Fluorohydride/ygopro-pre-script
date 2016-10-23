--暴走魔法陣
--Reckless Magic Circle
--Script by nekrozar
function c100406034.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100406034+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c100406034.activate)
	c:RegisterEffect(e1)
	--inactivatable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetValue(c100406034.efilter)
	c:RegisterEffect(e2)
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c100406034.limcon)
	e3:SetOperation(c100406034.limop)
	c:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCode(EVENT_CHAIN_END)
	e5:SetOperation(c100406034.limop2)
	c:RegisterEffect(e5)
end
function c100406034.thfilter(c)
	return c:IsCode(100406026) and c:IsAbleToHand()
end
function c100406034.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c100406034.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(100406034,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c100406034.efilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	return p==tp and te:IsHasCategory(CATEGORY_FUSION_SUMMON)
end
function c100406034.limfilter(c,tp)
	return c:GetSummonPlayer()==tp and bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c100406034.limcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100406034.limfilter,1,nil,tp)
end
function c100406034.limop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(c100406034.chainlm)
	elseif Duel.GetCurrentChain()==1 then
		e:GetHandler():RegisterFlagEffect(100406034,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c100406034.limop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(100406034)~=0 then
		Duel.SetChainLimitTillChainEnd(c100406034.chainlm)
	end
	e:GetHandler():ResetFlagEffect(100406034)
end
function c100406034.chainlm(e,rp,tp)
	return tp==rp
end

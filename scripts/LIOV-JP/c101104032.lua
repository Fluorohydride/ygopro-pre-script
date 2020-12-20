--ドグマティカ・アルバズ・ナイト
--Dogmatika Albaz Knight
--Scripted by Kohana Sonogami
--
function c101104032.initial_effect(c)
	c:EnableReviveLimit()
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101104032,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101104032.splimit)
	c:RegisterEffect(e1)
	--look
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101104032,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101104032)
	e2:SetCondition(c101104032.tgcon)
	e2:SetTarget(c101104032.tgtg)
	e2:SetOperation(c101104032.tgop)
	c:RegisterEffect(e2)
end
function c101104032.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x145)
end
function c101104032.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp
end
function c101104032.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c101104032.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT) and g:GetFirst():IsLocation(LOCATION_GRAVE) then
		local atk=g:GetFirst():GetTextAttack()
		local rg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,nil)
		if #rg>0 then
			Duel.ConfirmCards(tp,Duel.GetFieldGroup(tp,0,LOCATION_EXTRA))
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=rg:Select(tp,1,1,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT)
			Duel.ShuffleExtra(1-tp)
			if sg:GetFirst():IsLocation(LOCATION_GRAVE) then e:SetLabel(sg:GetFirst():GetTextAttack()) end
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue((atk+e:GetLabel())/2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end

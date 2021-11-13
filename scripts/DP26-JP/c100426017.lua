--海竜神-リバイアサン
--
--Script by Trishula9
function c100426017.initial_effect(c)
	aux.AddCodeList(c,22702055)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100426017)
	e1:SetTarget(c100426017.thtg)
	e1:SetOperation(c100426017.thop)
	c:RegisterEffect(e1)
	--adjust
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c100426017.condition)
	e2:SetOperation(c100426017.adjustop)
	c:RegisterEffect(e2)
	--cannot summon,spsummon,flipsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCondition(c100426017.condition)
	e3:SetTargetRange(1,1)
	e3:SetTarget(c100426017.sumlimit)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e5)
end
c100426017[0]=0
c100426017[1]=0
function c100426017.thfilter(c)
	return (c:IsCode(22702055) or c:IsSetCard(0x275,0x276) and c:IsType(TYPE_SPELL+TYPE_TRAP)) and c:IsAbleToHand()
end
function c100426017.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100426017.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100426017.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100426017.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c100426017.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(22702055)
end
function c100426017.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	if sumpos and bit.band(sumpos,POS_FACEDOWN)>0 then return false end
	return not c:IsAttribute(ATTRIBUTE_WATER) and c100426017[targetp or sump]==1
end
function c100426017.wtfilter(c)
	return not c:IsAttribute(ATTRIBUTE_WATER) and c:IsFaceup()
end
function c100426017.rmfilter(c,at)
	return c:GetAttribute()==at
end
function c100426017.tgselect(sg,g)
	return #(g-sg)==1 and not sg:IsExists(c100426017.rmfilter,1,nil,ATTRIBUTE_WATER)
end
function c100426017.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local g1=Duel.GetMatchingGroup(c100426017.wtfilter,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(c100426017.wtfilter,tp,0,LOCATION_MZONE,nil)
	local c=e:GetHandler()
	if g1:GetCount()==0 then c100426017[tp]=0
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g1:SelectSubGroup(tp,c100426017.tgselect,false,#g1-1,#g1-1,g1)
		if sg then
			g1:Sub(g1-sg)
		else
			g1:Sub(g1)
		end
		c100426017[tp]=1
	end
	if g2:GetCount()==0 then c100426017[1-tp]=0
	else
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g2:SelectSubGroup(1-tp,c100426017.tgselect,false,#g2-1,#g2-1,g2)
		if sg then
			g2:Sub(g2-sg)
		else
			g2:Sub(g2)
		end
		c100426017[1-tp]=1
	end
	g1:Merge(g2)
	if g1:GetCount()>0 then
		Duel.SendtoGrave(g1,REASON_RULE)
		Duel.Readjust()
	end
end
